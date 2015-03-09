--怪异杀手 刃下心
function c59800013.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x598),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c59800013.ractg)
	e1:SetOperation(c59800013.racop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c59800013.descon)
	e2:SetTarget(c59800013.destg)
	e2:SetOperation(c59800013.desop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--spsum success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,59800013)
	e3:SetCondition(c59800013.spcon)
	e3:SetTarget(c59800013.sptg)
	e3:SetOperation(c59800013.spop)
	c:RegisterEffect(e3)
end
function c59800013.ractg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if e:GetHandler():GetFlagEffect(159800013)==0 then
		e:GetHandler():RegisterFlagEffect(159800013,RESET_EVENT+0x1fe0000,0,0)
		e:GetLabelObject():SetLabel(0)
	end
	local prc=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local rc=Duel.AnnounceAttribute(tp,1,0x7f-prc)
	e:SetLabel(rc)
end
function c59800013.racop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local prc=e:GetLabelObject():GetLabel()
		local rc=bit.bor(e:GetLabel(),prc)
		e:GetLabelObject():SetLabel(rc)
		e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
	end
end
function c59800013.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:GetFlagEffect(159800013)~=0 and bc and bc:IsFaceup() and bc:IsAttribute(e:GetLabel())
end
function c59800013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c59800013.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c59800013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c59800013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c59800013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

