--狂气的赤眼 铃仙·优昙华院·因幡
function c73700009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x737),aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),true)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,73700009)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c73700009.ctltg)
	e1:SetOperation(c73700009.ctlop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c73700009.condition)
	e2:SetTarget(c73700009.target)
	e2:SetOperation(c73700009.activate)
	c:RegisterEffect(e2)
end
function c73700009.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsControlerCanBeChanged()
end
function c73700009.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c73700009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73700009.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c73700009.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c73700009.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not Duel.GetControl(tc,tp,PHASE_BATTLE,1) then
			if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end
function c73700009.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c73700009.filter1(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c73700009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ag=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if chk==0 then return ag:IsExists(c73700009.filter1,1,at,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=ag:FilterSelect(tp,c73700009.filter1,1,1,at,e)
	Duel.SetTargetCard(g)
end
function c73700009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end