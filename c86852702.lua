--機甲部隊の再編制
function c86852702.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86852702,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86852702+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c86852702.target)
	e1:SetOperation(c86852702.activate)
	c:RegisterEffect(e1)
end
function c86852702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c86852702.target1(e,tp,eg,ep,ev,re,r,rp,0) and c86852702.cost1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c86852702.target2(e,tp,eg,ep,ev,re,r,rp,0) and c86852702.cost2(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(86852702,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(86852702,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	if sel==1 then
		e:SetCost(c86852702.cost1)
		c86852702.cost1(e,tp,eg,ep,ev,re,r,rp,1)
		c86852702.target1(e,tp,eg,ep,ev,re,r,rp,1)
	elseif sel==2 then
		e:SetCost(c86852702.cost2)
		c86852702.cost2(e,tp,eg,ep,ev,re,r,rp,1)
		c86852702.target2(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c86852702.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
	local g=Duel.GetMatchingGroup(c86852702.thfilter1,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if hg then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
	elseif sel==2 then
	local g=Duel.GetMatchingGroup(c86852702.thfilter2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if hg then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
	end
end
function c86852702.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c86852702.thfilter1(c)
	return c:IsSetCard(0x36) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c86852702.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c86852702.thfilter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c86852702.costfilter(c)
	return c:IsSetCard(0x36) and c:IsDiscardable()
end
function c86852702.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c86852702.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c86852702.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c86852702.thfilter2(c)
	return c:IsSetCard(0x36) and not c:IsCode(86852702) and c:IsAbleToHand()
end
function c86852702.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c86852702.thfilter2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
