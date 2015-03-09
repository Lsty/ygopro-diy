--幻胧月睨 铃仙·优昙华院·因幡
function c73700005.initial_effect(c)
	--change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c73700005.cbcon)
	e1:SetTarget(c73700005.thtg)
	e1:SetOperation(c73700005.cbop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCountLimit(1)
	e2:SetCondition(c73700005.condition)
	e2:SetCost(c73700005.descost)
	e2:SetTarget(c73700005.target)
	e2:SetOperation(c73700005.activate)
	c:RegisterEffect(e2)
end
function c73700005.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and bt:IsFaceup() and bt:IsSetCard(0x737) and bt:GetControler()==c:GetControler()
end
function c73700005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c73700005.cbop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		if Duel.SelectYesNo(tp,aux.Stringid(73700005,0)) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(e:GetHandler())
		end
	end
end
function c73700005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c73700005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,e:GetHandler(),RACE_BEAST) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,1,e:GetHandler(),RACE_BEAST)
	Duel.Release(g,REASON_COST)
end
function c73700005.spfilter(c)
	return c:IsSetCard(0x737) and c:IsFaceup()
end
function c73700005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c73700005.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73700005.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c73700005.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c73700005.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	local def=tc:GetDefence()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetValue(atk*2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE)
		e2:SetValue(def*2)
		tc:RegisterEffect(e2)
	end
end