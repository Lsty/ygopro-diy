--魔女の証
function c114000376.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c114000376.cost)
	e1:SetTarget(c114000376.target)
	e1:SetOperation(c114000376.activate)
	c:RegisterEffect(e1)
end

function c114000376.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114000376)==0 end
	Duel.RegisterFlagEffect(tp,114000376,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c114000376.filter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsRace(RACE_SPELLCASTER) and Duel.IsExistingMatchingCard(c114000376.spfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp)
end
function c114000376.spfilter(c,att,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(att)
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114000376.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000376.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114000376.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c114000376.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c114000376.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		local tg=g:GetFirst()
		local att=tg:GetAttribute()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c114000376.spfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp)
		Duel.SpecialSummon(g2,301,tp,tp,false,false,POS_FACEUP)
	end
end