--幻弹「幻想视差」
function c73700016.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetCountLimit(1,73700016+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c73700016.operation)
	c:RegisterEffect(e1)
end
function c73700016.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c73700016.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,73700017,RESET_PHASE+PHASE_END,0,1)
end
function c73700016.filter(c,tp)
	return c:IsSetCard(0x737) and c:IsPreviousPosition(POS_FACEUP)
		and not c:IsLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c73700016.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c73700016.filter,1,nil,tp) and rp~=tp and bit.band(r,REASON_BATTLE)==0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end