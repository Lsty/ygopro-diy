--圣煌天的麒麟 朔夜
function c3036101.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c3036101.spcost)
	e1:SetTarget(c3036101.sptg)
	e1:SetOperation(c3036101.spop)
	c:RegisterEffect(e1)
   	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c3036101.tg)
	e1:SetOperation(c3036101.op)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c3036101.target)
	e1:SetOperation(c3036101.operation)
	c:RegisterEffect(e1)
end
function c3036101.spfilter1(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c3036101.spfilter2(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c3036101.spfilter3(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsPublic()
end
function c3036101.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036101.spfilter1,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036101.spfilter2,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036101.spfilter3,tp,LOCATION_HAND,0,1,nil,nil)
        and Duel.GetFlagEffect(tp,3036101)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c3036101.spfilter1,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c3036101.spfilter2,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g3=Duel.SelectMatchingCard(tp,c3036101.spfilter3,tp,LOCATION_HAND,0,1,1,nil,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,3036101,RESET_PHASE+PHASE_END,0,1)
end
function c3036101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3036101.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c3036101.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c3036101.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c3036101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c3036101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c3036101.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c3036101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c3036101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036101.hfilter,tp,LOCATION_GRAVE,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c3036101.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c3036101.hfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c3036101.hfilter(c)
	return c:GetLevel()==7 and c:IsAbleToHand()
end