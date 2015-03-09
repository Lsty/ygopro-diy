--LabMem No.001-冈部伦太郎
function c20400001.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c20400001.sptg)
	e1:SetOperation(c20400001.spop)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c20400001.thtg)
	e4:SetOperation(c20400001.thop)
	c:RegisterEffect(e4)
	if not LabMemGlobal then
		LabMemGlobal={}
		LabMemGlobal["Effects"]={}
	end
	LabMemGlobal["Effects"]["c20400001"]=e4
end
function c20400001.spfilter(c,e,tp)
	return c:IsSetCard(0x204) and not c:IsType(TYPE_XYZ) and c:GetLevel()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20400001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20400001.spfilter(chkc,e,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c20400001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20400001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c20400001.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c20400001.thfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsStatus(STATUS_LEAVE_CONFIRMED) and c:GetSequence()~=6 and c:GetSequence()~=7
end
function c20400001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c20400001.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20400001.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20400001.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c20400001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then
			Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENCE,0)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end