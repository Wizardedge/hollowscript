--Imperial Bower
function c56673112.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56673112,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,56673112)
	e1:SetCondition(c56673112.spcon)
	e1:SetCost(c56673112.spcost)
	e1:SetTarget(c56673112.sptg)
	e1:SetOperation(c56673112.spop)
	c:RegisterEffect(e1)
end
function c56673112.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c56673112.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c56673112.opfilter(c,e,tp,ft)
	return (c:IsAbleToHand() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and ft>0)) and c:IsCode(64788463,25652259,90876561)
end
function c56673112.opcheck(g,e,tp,spcheck)
	return g:GetClassCount(Card.GetCode)==2
	and not (g:FilterCount(Card.IsAbleToHand,nil)<1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function c56673112.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c56673112.opfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
		return g:CheckSubGroup(c56673112.opcheck,2,2,e,tp)
	end
end
function c56673112.spop(e,tp,eg,ep,ev,re,r,rp)
	local spcheck=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c56673112.opfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c56673112.opcheck,false,2,2,e,tp,spcheck)
	if not sg then return end
	local spchk=0
	local th=Group.CreateGroup()
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			th:AddCard(tc)
		else
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then spchk=1 end
		end
	end
	local tc=(sg-tc):Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or spchk==1 or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			th:AddCard(tc)
		else
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if th:GetCount()>0 then
		Duel.ConfirmCards(1-tp,th)
	end
	Duel.SpecialSummonComplete()
end
