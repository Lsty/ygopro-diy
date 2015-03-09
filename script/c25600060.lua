--戦闘モードの「美波の“召喚獣”」＆「瑞希の“召喚獣”」
function c25600060.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,aux.FilterBoolFunction(Card.IsCode,25600010),aux.FilterBoolFunction(Card.IsCode,25600009),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c25600060.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c25600060.sprcon)
	e2:SetOperation(c25600060.sprop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c25600060.damtg)
	e3:SetOperation(c25600060.damop)
	c:RegisterEffect(e3)
	--update atk,def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c25600060.val)
	c:RegisterEffect(e4)
	--return
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_REPEAT)
	e6:SetCondition(c25600060.retcon1)
	e6:SetTarget(c25600060.rettg)
	e6:SetOperation(c25600060.retop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(0)
	e7:SetCondition(c25600060.retcon2)
	c:RegisterEffect(e7)
end
function c25600060.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c25600060.spfilter1(c,tp)
	local tpe=c:GetOriginalType()
	return c:IsCode(25600010) and c:IsCanBeFusionMaterial() and ((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToExtraAsCost()) or (bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToDeckAsCost())) and Duel.IsExistingMatchingCard(c25600060.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c25600060.spfilter2(c)
	local tpe=c:GetOriginalType()
	return c:IsCode(25600009) and c:IsCanBeFusionMaterial() and ((bit.band(tpe,TYPE_FUSION)>0 and c:IsAbleToExtraAsCost()) or (bit.band(tpe,TYPE_FUSION)==0 and c:IsAbleToDeckAsCost()))
end
function c25600060.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c25600060.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c25600060.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25600060,0))
	local g1=Duel.SelectMatchingCard(tp,c25600060.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25600060,1))
	local g2=Duel.SelectMatchingCard(tp,c25600060.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c25600060.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(900)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,900)
end
function c25600060.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c25600060.val(e,c)
	local v=Duel.GetLP(c:GetControler())-Duel.GetLP(1-c:GetControler())
	if v>0 then return v else return 0 end
end
function c25600060.retcon1(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsHasEffect(23300015)
end
function c25600060.retcon2(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsHasEffect(23300015)
end
function c25600060.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c25600060.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
