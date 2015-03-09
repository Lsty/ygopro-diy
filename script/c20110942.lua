--轨迹-兰迪
function c20110942.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20110942.hspcon)
	e1:SetOperation(c20110942.hspop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c20110942.spcon)
	e1:SetTarget(c20110942.sptg)
	e1:SetOperation(c20110942.spop)
	c:RegisterEffect(e1)
end
function c20110942.spfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x929)
end
function c20110942.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(tp,20110941)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c20110942.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c20110942.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,20110941,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c20110942.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c20110942.sfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c20110942.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==1-tp and chkc:GetLocation()==LOCATION_ONFIELD and c20110942.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20110942.sfilter,1-tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20110942.sfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c20110942.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
