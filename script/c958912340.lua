--Haunted Bones' Call
function c958912340.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c958912340.runcon)
	r1:SetOperation(c958912340.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(958912340,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c958912340.settg)
	e3:SetOperation(c958912340.setop)
	c:RegisterEffect(e3)
end
function c958912340.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c958912340.matfilter2(c)
	return c:IsFaceup() and c:GetCode()==97077563
end
function c958912340.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c958912340.matfilter1,c:GetControler(),LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(c958912340.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c958912340.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c958912340.matfilter1,c:GetControler(),LOCATION_MZONE,0,2,2,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c958912340.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,1,nil,c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c958912340.filter(c)
	return c:IsCode(97077563) and c:IsSSetable(true)
end
function c958912340.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c958912340.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c958912340.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c958912340.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
