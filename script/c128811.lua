--月见的混沌天使 暗魂
function c128811.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(128811,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c128811.discost)
	e2:SetCountLimit(1,128811)
	e2:SetTarget(c128811.target)
	e2:SetOperation(c128811.operation)
	c:RegisterEffect(e2)
end
function c128811.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c128811.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(128811,1))
end
function c128811.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=c:GetLevel()
	local mg=Duel.GetMatchingGroup(c128811.matfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if mg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetLevel(),1,99,c)
		c:SetMaterial(mat)
		Duel.SpecialSummon(mat,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c128811.matfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end