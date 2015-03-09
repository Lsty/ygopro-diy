--天之剑艺 比那名居天子
function c6668626.initial_effect(c)
	c:SetUniqueOnField(1,0,6668626)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6668620,c6668626.ffilter,1,true,true)
	--spsummon
     local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c6668626.settg)
	e1:SetOperation(c6668626.setop)
	c:RegisterEffect(e1)
	--multiattack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c6668626.val)
	c:RegisterEffect(e2)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x742))
	c:RegisterEffect(e4)
end
function c6668626.ffilter(c)
	return c:IsSetCard(0x740) and c:IsType(TYPE_SYNCHRO)
end
function c6668626.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x742)
end
function c6668626.val(e,c)
	return Duel.GetMatchingGroupCount(c6668626.afilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
end
function c6668626.filter(c)
	return c:IsSetCard(0x742) and c:IsSSetable()
end
function c6668626.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c6668626.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c6668626.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c6668626.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local tc=g:GetFirst()
			if tc:IsType(TYPE_TRAP) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			tc:RegisterEffect(e3)
			else
			if tc:IsType(TYPE_QUICKPLAY) then tc:SetStatus(STATUS_SET_TURN,false) end
		end
		local c=e:GetHandler()
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
					local tep=tc:GetControler()
					if not te then
						Duel.SendtoGrave(tc,REASON_EFFECT)
					else
						local condition=te:GetCondition()
						local cost=te:GetCost()
						local target=te:GetTarget()
						local operation=te:GetOperation()
						if te:GetCode()==EVENT_FREE_CHAIN
							and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
							and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
							and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
							Duel.ClearTargetCard()
							e:SetProperty(te:GetProperty())
							Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
							Duel.ChangePosition(tc,POS_FACEUP)
							if not tc:IsType(TYPE_CONTINUOUS) then tc:CancelToGrave(false) end
							tc:CreateEffectRelation(te)
							if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
							if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
							local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
							local tg=g:GetFirst()
							while tg do
								tg:CreateEffectRelation(te)
								tg=g:GetNext()
							end
							if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
							tc:ReleaseEffectRelation(te)
							tg=g:GetFirst()
							while tg do
								tg:ReleaseEffectRelation(te)
								tg=g:GetNext()
							end
						else
							Duel.SendtoGrave(tc,REASON_EFFECT)
							end
					end
    end
end