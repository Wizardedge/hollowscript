--CNo.5 亡朧龍カオス・キマイラ・ドラゴン
function c69757518.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,nil,nil,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c69757518.atkval)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69757518,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c69757518.atcon)
	e2:SetCost(c69757518.atcost)
	e2:SetOperation(c69757518.atop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69757518,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c69757518.cost)
	e3:SetTarget(c69757518.target)
	e3:SetOperation(c69757518.operation)
	c:RegisterEffect(e3)
end
c69757518.xyz_number=5
function c69757518.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c69757518.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0,true)
end
function c69757518.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69757518.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
end
function c69757518.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c69757518.tdfilter(c,g)
	return c:IsAbleToDeck() and g:IsExists(Card.IsCanOverlay,1,c)
end
function c69757518.fselect(g)
	return g:IsExists(c69757518.tdfilter,1,nil,g)
end
function c69757518.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and g:CheckSubGroup(c69757518.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c69757518.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,2,0,0)
end
function c69757518.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=sg:FilterSelect(tp,c69757518.tdfilter,1,1,nil,sg)
		if sg1:GetCount()==0 then sg1:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil) end
		local c=e:GetHandler()
		sg:Sub(sg1)
		if sg1:GetCount()>0 and Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and sg:IsExists(Card.IsCanOverlay,1,nil) then
			Duel.Overlay(c,sg)
		end
	end
end
