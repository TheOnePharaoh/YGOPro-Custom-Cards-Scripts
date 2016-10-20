--Core Unit Assault
function c989512323.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c989512323.runcon)
	r1:SetOperation(c989512323.runop)
	r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--Attack Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetCondition(c989512323.atkcon)
	c:RegisterEffect(e1)
	--Indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c989512323.indtg)
	e2:SetValue(c989512323.indval)
	c:RegisterEffect(e2)
end
function c989512323.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE)
end
function c989512323.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP)
end
function c950129342.runfilter1(c)
	return c950129342.matfilter1(c) and Duel.IsExistingMatchingCard(c950129342.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c950129342.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c950129342.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c950129342.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,c950129342.runfilter1,c:GetControler(),LOCATION_MZONE,0,1,1,nil,c)
	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c950129342.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,1,1,g1:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c989512323.atkcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c989512323.indtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c989512323.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
