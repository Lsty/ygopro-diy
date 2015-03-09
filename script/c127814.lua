--精灵 时崎狂三
function c127814.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9fa),4,3)
	c:SetUniqueOnField(1,0,127814)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c127814.operation)
	c:RegisterEffect(e1)
end
function c127814.filter(c,e,tp)
	return c:IsSetCard(0x9fa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c127814.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=e:GetHandler():GetOverlayGroup(tp,1,0)
	local sg=g1:Filter(c127814.filter,nil,e,tp)
	if ft==0 or sg==0  then return end
	local mg=sg:Select(tp,ft,ft,nil)
	local fid=e:GetHandler():GetFieldID()
	local tc=mg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(127814,RESET_EVENT+0x1fe0000,0,1,fid)
		tc=mg:GetNext()
	end
	Duel.SpecialSummonComplete()
	mg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(mg)
	e1:SetOperation(c127814.retop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DESTROY)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(mg)
	e2:SetOperation(c127814.desop)
	e:GetHandler():RegisterEffect(e2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c127814.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c127814.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x9fa) 
end
function c127814.retfilter(c,fid)
	return c:GetFlagEffectLabel(127814)==fid
end
function c127814.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tg=g:Filter(c127814.retfilter,nil,e:GetLabel())
	local tc=tg:GetFirst()
	if c:IsFaceup() then
		while tc do
		Duel.Overlay(c,Group.FromCards(tc))
		tc=tg:GetNext()
		end
	end
end
function c127814.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local tg=g:Filter(c127814.retfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
