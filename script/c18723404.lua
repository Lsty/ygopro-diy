--灵使少女 希塔
function c18723404.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95027497,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,18723404)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c18723404.tg1)
	e1:SetOperation(c18723404.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c18723404.con)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73176465,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,18723404)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c18723404.discon)
	e1:SetTarget(c18723404.distarget)
	e1:SetOperation(c18723404.disoperation)
	c:RegisterEffect(e1)
end
function c18723404.filter1(c)
	return c:IsSetCard(0xabb) and c:IsAbleToHand() and c:IsSetCard(0xbf) and not c:IsCode(18723404)
end
function c18723404.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18723404.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18723404.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18723404.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c18723404.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_MONSTER)
end
function c18723404.discon(e,tp,eg,ep,ev,re,r,rp)
	return (bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xabb) and re:GetHandler():IsType(TYPE_MONSTER)) or (e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xabb))
end
function c18723404.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18723404.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18723404.disoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18723404.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c18723404.thfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xabb) and c:IsSetCard(0xbf) and not c:IsCode(18723404)
end