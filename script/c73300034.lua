--命运之斯卡雷特
function c73300034.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c73300034.condition)
	e1:SetCost(c73300034.spcost)
	e1:SetTarget(c73300034.sptg)
	e1:SetOperation(c73300034.spop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(c73300034.thcost)
	e3:SetTarget(c73300034.target)
	e3:SetOperation(c73300034.operation)
	c:RegisterEffect(e3)
end
function c73300034.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not (c:IsSetCard(0x734) or c:IsSetCard(0x878) or c:IsSetCard(0x879) or c:GetCode()==73300020)
end
function c73300034.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c73300034.filter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c73300034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,73300034)==0 end
	Duel.RegisterFlagEffect(tp,73300034,RESET_PHASE+PHASE_END,0,1)
end
function c73300034.filter(c,e,tp)
	return (c:IsSetCard(0x733) or c:IsSetCard(0x877) or c:GetCode()==73300034 or c:GetCode()==87700018) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73300034.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c73300034.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingTarget(c73300034.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c73300034.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c73300034.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c73300034.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,73300034)==0 end
	Duel.RegisterFlagEffect(tp,73300034,RESET_PHASE+PHASE_END,0,1)
end
function c73300034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73300034.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73300034.filter1(c)
	return c:GetCode()==87700018 and c:IsAbleToHand()
end
function c73300034.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetFirstMatchingCard(c73300034.filter1,tp,LOCATION_DECK,0,nil)
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end