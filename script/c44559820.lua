--Xing Tian, Berserk God of the Sky Nirvana
function c44559820.initial_effect(c)
	c:SetUniqueOnField(1,0,44559820)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--destroy&damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44559820,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c44559820.descon)
	e2:SetTarget(c44559820.destg)
	e2:SetOperation(c44559820.desop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
  --shuffle&draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44559820,0))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1,44559820)
	e4:SetTarget(c44559820.drtg)
	e4:SetOperation(c44559820.drop)
	c:RegisterEffect(e4)
end
function c44559820.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559820.desfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c44559820.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c44559820.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	end
end
function c44559820.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c44559820.desfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function c44559820.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c44559820.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)then return end
  if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) ~=0 then
    Duel.ShuffleDeck(tp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
  end
end