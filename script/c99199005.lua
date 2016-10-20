--The Future Gear Psychic Delta Draco
function c99199005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99199005.splimit)
	e2:SetCondition(c99199005.splimcon)
	c:RegisterEffect(e2)
	--atk and def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c99199005.tg1)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTarget(c99199005.tg2)
	e4:SetValue(-400)
	c:RegisterEffect(e4)
	--spsummon and copy level
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99199005,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c99199005.sptg)
	e5:SetOperation(c99199005.spop)
	c:RegisterEffect(e5)
end
function c99199005.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xff15) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c99199005.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c99199005.tg1(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199005.tg2(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99199005.filter(c,e,tp)
	return c:IsSetCard(0xff15) and c:IsLevelBelow(6) and not c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99199005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99199005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c99199005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99199005.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(g:GetFirst():GetLevel())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		end
	end
end
