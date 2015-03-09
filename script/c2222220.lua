--契约·召唤
function c2222220.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c2222220.sccost)
	e2:SetTarget(c2222220.target)
	e2:SetOperation(c2222220.activate)
	c:RegisterEffect(e2)
      --Spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2222220,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c2222220.discon)
	e3:SetCost(c2222220.spcost)
	e3:SetTarget(c2222220.sptg)
	e3:SetOperation(c2222220.spop)
	c:RegisterEffect(e3)

end
function c2222220.cfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost() 
end
function c2222220.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222220.cfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c2222220.cfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c2222220.scfilter(c,e,tp)
	return c:IsSetCard(0x203) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2222220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c2222220.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c2222220.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(c2222220.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c2222220.hfilter(c)
	return c:GetCode()==2222223
end
function c2222220.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2222220.hfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function c2222220.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c2222220.sgfilter(c)
       return c:GetType()==0x4 and c:IsAbleToGrave()
end
function c2222220.spfilter(c,e,tp)
	return c:GetCode()==2222223 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function c2222220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222220.sgfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK) 
end
function c2222220.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c2222220.sgfilter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT) 
            Duel.BreakEffect()
          	local sc=Duel.GetFirstMatchingCard(c2222220.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if sc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			end
end
end
