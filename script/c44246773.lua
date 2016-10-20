--Vocaloid Rook
function c44246773.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c44246773.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c44246773.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c44246773.spcon)
	e2:SetOperation(c44246773.spop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(44246773,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c44246773.con1)
	e3:SetTarget(c44246773.tg1)
	e3:SetOperation(c44246773.op1)
	c:RegisterEffect(e3)
	--handes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44246773,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c44246773.con2)
	e4:SetTarget(c44246773.tg2)
	e4:SetOperation(c44246773.op2)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c44246773.indval)
	c:RegisterEffect(e5)
end
function c44246773.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER)
end
function c44246773.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c44246773.spfilter1(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c44246773.spfilter2,1,c)
end
function c44246773.spfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial()
end
function c44246773.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c44246773.spfilter1,1,nil,tp)
end
function c44246773.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c44246773.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c44246773.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c44246773.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(44246773)==0
end
function c44246773.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c44246773.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c44246773.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(44246773)==0
end
function c44246773.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c44246773.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c44246773.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
	end