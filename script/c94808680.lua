--Vocaloid Utane Uta
function c94808680.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c94808680.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c94808680.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c94808680.spcon)
	e2:SetOperation(c94808680.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94808680,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c94808680.eqcon)
	e3:SetTarget(c94808680.eqtg)
	e3:SetOperation(c94808680.eqop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c94808680.indval)
	c:RegisterEffect(e4)
end
function c94808680.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c94808680.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c94808680.spfilter1(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeFusionMaterial()
		and Duel.CheckReleaseGroup(tp,c94808680.spfilter2,1,c)
end
function c94808680.spfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeFusionMaterial()
end
function c94808680.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c94808680.spfilter1,1,nil,tp)
end
function c94808680.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c94808680.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c94808680.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c94808680.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(94808680)==0
end
function c94808680.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c94808680.eqlimit(e,c)
	return e:GetOwner()==c
end
function c94808680.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			local def=tc:GetTextDefense()
			if tc:IsFacedown() or atk<0 then atk=0 end
			if tc:IsFacedown() or def<0 then def=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(94808680,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c94808680.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_SET_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
			if def>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e3:SetCode(EFFECT_SET_DEFENSE)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				e3:SetValue(def)
				tc:RegisterEffect(e3)
			end
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_EQUIP)
			e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
			e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			e4:SetValue(c94808680.repval)
			tc:RegisterEffect(e4)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c94808680.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c94808680.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end